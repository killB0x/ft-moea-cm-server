package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"

	_ "github.com/go-sql-driver/mysql"
)

type UploadData struct {
	Run_id                    int64       `json:"run_id"`
	Dataset                   string      `json:"dataset"`
	Trees                     []string    `json:"trees"`
	Attribute_data            [][]float64 `json:"attribute_data"`
	Is_multithreading_enabled bool        `json:"is_multithreading_enabled"`
	Metric_config             string      `json:"metric_config"`
}

type Test struct {
	Key string `json:"key"`
}

func postHandler(w http.ResponseWriter, r *http.Request) {
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

	var recievedData UploadData
	fmt.Println("String:", string(body))
	err = json.Unmarshal(body, &recievedData)

	if err != nil {
		fmt.Println("Error parsing json object", err)
		http.Error(w, "Bad Request", http.StatusBadRequest)
		return
	}

	fmt.Println("Received POST data:", recievedData)

	// You can add more logic here to react to the POST request.

	w.WriteHeader(http.StatusOK)
	w.Write([]byte("Successfully received POST request"))
}

func main() {
	// Define the DSN (Data Source Name).
	dsn := "root:password@tcp(127.0.0.1:3307)/main"

	// Establish the connection.
	db, err := sql.Open("mysql", dsn)

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

	http.HandleFunc("/hello", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, man!")
		fmt.Print("request sent!")
	})

	http.HandleFunc("/evolutionary_data", postHandler)

	fmt.Printf("Starting server at port 8080\n")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err)
	}
}
