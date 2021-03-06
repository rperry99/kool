package main

import (
	"log"
	"os"

	"kool-dev/kool/cmd"
	"kool-dev/kool/environment"
)

func main() {
	log.SetFlags(log.Ldate | log.Ltime | log.Lmicroseconds)
	environment.InitEnvironmentVariables()

	if err := cmd.Execute(); err != nil {
		log.Fatal(err)
		os.Exit(1)
	}
}
