package main

import (
	"bufio"
	"database/sql"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"

	_ "github.com/go-sql-driver/mysql"
)

var db *sql.DB
var validApiKeys []string

type UploadData struct {
	Run_id                    int64       `json:"run_id"`
	Dataset                   string      `json:"dataset"`
	Trees                     []string    `json:"trees"`
	Attribute_data            [][]float64 `json:"attribute_data"`
	Is_multithreading_enabled bool        `json:"is_multithreading_enabled"`
	Metric_config             string      `json:"metric_config"`
	Time                      float64     `json:"time"`
}

type FinishRunId struct {
	Run_id int64 `json:"run_id"`
}

func checkAPIKey(r *http.Request, validAPIKeys []string) bool {
	incomingAPIKey := r.Header.Get("X-API-Key")
	for _, validKey := range validAPIKeys {
		if incomingAPIKey == validKey {
			return true
		}
	}
	return false
}

func postHandler(w http.ResponseWriter, r *http.Request) {

	if !checkAPIKey(r, validApiKeys) {
		fmt.Println("Unauthorized connection attempt")
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	if r.Method != http.MethodPost {
		fmt.Println("Only POST method is allowed")
		http.Error(w, "Only POST method is allowed", http.StatusMethodNotAllowed)
		return
	}

	body, err := io.ReadAll(r.Body)
	if err != nil {
		fmt.Println("Failed to read body")
		http.Error(w, "Failed to read body", http.StatusBadRequest)
		return
	}

	fmt.Println("Path", r.URL.Path)
	switch r.URL.Path {
	case "/evolutionary_data":
		var recievedData UploadData
		err = json.Unmarshal(body, &recievedData)

		if err != nil {
			fmt.Println("Error parsing json object", err)
			http.Error(w, "Bad Request", http.StatusBadRequest)
			return
		}
		uploadDataToDB(recievedData)
	case "/end_run":
		var idData FinishRunId
		err = json.Unmarshal(body, &idData)
		fmt.Println("uppdateId", idData)
		if err != nil {
			fmt.Println("Error parsing json object", err)
			http.Error(w, "Bad Request", http.StatusBadRequest)
			return
		}

		finishRun(idData)
	}

	// You can add more logic here to react to the POST request.

	w.WriteHeader(http.StatusOK)
	w.Write([]byte("Successfully received POST request"))
}

func finishRun(data FinishRunId) {
	result, err := db.Exec("UPDATE run SET completed = ? WHERE idRun = ?", 1, data.Run_id)
	if err != nil {
		log.Fatal(err)
	}

	rowsAffected, err := result.RowsAffected()
	fmt.Println("Rows affected", rowsAffected, data.Run_id)
}

func uploadDataToDB(data UploadData) {
	// Upload the data as transactions to prevent pollution in case of failure
	tx, err := db.Begin()
	if err != nil {
		log.Fatal(err)
	}

	_, err = tx.Exec("INSERT IGNORE INTO run (idRun, isMultithreadingEnabled, metricConfig, usedDataset) VALUES (?, ?, ?, ?)", data.Run_id, data.Is_multithreading_enabled, data.Metric_config, data.Dataset)
	if err != nil {
		log.Fatal(err)
		tx.Rollback() // Important
	}

	res, err := tx.Exec("INSERT INTO generation (idRun, time) VALUES (?, ?)", data.Run_id, data.Time)
	if err != nil {
		log.Fatal(err)
		tx.Rollback() // Important
	}

	// add the trees to the database
	idGeneration, err := res.LastInsertId()

	for i := 0; i < len(data.Trees); i++ {
		res, err := tx.Exec("INSERT INTO trees (idGeneration, tree) VALUES (?, ?)", idGeneration, data.Trees[i])
		if err != nil {
			log.Fatal(err)
			tx.Rollback() // Important
		}

		idTree, err := res.LastInsertId()
		if err != nil {
			log.Fatal(err)
			tx.Rollback() // Important
			return
		}

		for j := 0; j < len(data.Metric_config); j++ {
			if data.Metric_config[j] == '0' {
				continue
			}

			_, err := tx.Exec("INSERT INTO tree_data (treeId, value, attributeId) VALUES (?, ?, ?)", idTree, data.Attribute_data[i][j], j)
			if err != nil {
				log.Fatal(err)
				tx.Rollback() // Important
			}
		}
	}

	tx.Commit()
}

func loadValidAPIKeys(filename string) ([]string, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	var validAPIKeys []string
	for scanner.Scan() {
		validAPIKeys = append(validAPIKeys, scanner.Text())
	}

	if err := scanner.Err(); err != nil {
		return nil, err
	}

	return validAPIKeys, nil
}

func main() {
	// Define the DSN (Data Source Name).
	dsn := "root:password@tcp(127.0.0.1:3307)/main"
	validApiKeys, _ = loadValidAPIKeys("./valid_api_keys.txt")

	// Establish the connection.
	var err error
	db, err = sql.Open("mysql", dsn)

	if err != nil {
		log.Fatal(err)
	}

	// Close the database connection when main() exits.
	defer db.Close()

	// Test the connection.
	err = db.Ping()
	if err != nil {
		fmt.Print("Unable to connect to database:", err)
		log.Fatal(err)
	}

	fmt.Println("Successfully connected to the database!")

	http.HandleFunc("/evolutionary_data", postHandler)
	http.HandleFunc("/end_run", postHandler)

	fmt.Printf("Starting server at port 8080\n")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err)
	}
}
