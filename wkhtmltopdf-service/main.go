package main

import (
    "fmt"
    "log"
    "net/http"
    "os/exec"
    "strings"
)

func runWkhtmltopdf(w http.ResponseWriter, r *http.Request) {
    if (r.Method == "POST") {
       err := r.ParseForm()
       if(err == nil) {
           cmdArgs := strings.Fields(r.Form.Get("params"))

           fmt.Println(cmdArgs)
           out, err := exec.Command("wkhtmltopdf", cmdArgs[0:len(cmdArgs)]...).Output();
           if( err == nil ) {
             fmt.Print(out)
             w.Header().Set("Content-Type", "application/octet-stream")
             w.Write(out)
             fmt.Println(out)
             return;
           }
       }
    }
    http.Error(w, http.StatusText(http.StatusBadRequest), http.StatusBadRequest)
}
func handleRequests() {
    http.HandleFunc("/", runWkhtmltopdf)
    log.Fatal(http.ListenAndServe(":9800", nil))
}

func main() {
    handleRequests()
}
