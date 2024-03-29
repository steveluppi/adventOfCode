package main

import (
	"bufio"
	"fmt"
	"os"
)

func readLinesToStringArray(path string) ([]string, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var lines []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	return lines, scanner.Err()
}

func silver() (){
}

func gold() (){
}


func main() {
	lines,_ := readLinesToStringArray("./example.txt")
	for i, line := range(lines){
		fmt.Println(i, line)
	}
}
