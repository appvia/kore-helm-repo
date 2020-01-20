package main

import (
	"log"
	"net/http"
	"regexp"
)

var (
	yamlFile = regexp.MustCompile("\\.yaml$")
	server   = http.StripPrefix("/charts/", http.FileServer(http.Dir("./charts/")))
)

func main() {
	http.HandleFunc(
		"/charts/",
		serve)

	log.Println("Listening...")
	http.ListenAndServe(":3000", nil)
}

func serve(w http.ResponseWriter, r *http.Request) {
	ruri := r.RequestURI
	if yamlFile.MatchString(ruri) {
		w.Header().Set("Content-Type", "text/yaml")
	}
	server.ServeHTTP(w, r)
}
