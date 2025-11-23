package main

import (
	"flag"
	"fmt"
	"os"
	"strings"
)

func main() {
	// Define CLI flags
	filename := flag.String("file", "", "Path to the file to process")
	secret := flag.String("secret", "", "Secret value to replace <umami-side-id>")
	flag.Parse()

	// Validate inputs
	if *filename == "" || *secret == "" {
		fmt.Println("Usage: go run main.go -file <filename> -secret <secret>")
		os.Exit(1)
	}

	// Read file content
	content, err := os.ReadFile(*filename)
	if err != nil {
		fmt.Printf("Error reading file: %v\n", err)
		os.Exit(1)
	}

	// Replace occurrences
	updated := strings.ReplaceAll(string(content), "<umami-side-id>", *secret)

	// Write back to file
	err = os.WriteFile(*filename, []byte(updated), 0644)
	if err != nil {
		fmt.Printf("Error writing file: %v\n", err)
		os.Exit(1)
	}

	fmt.Println("Replacement successful!")
}
