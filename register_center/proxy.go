package main

import (
	"bytes"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"regexp"
	"strings"
)

const regisert = `{"state":1,"data":{"id":"10","account_id":"sal27i44_org_key201209eaejug07te","origin_site_id":"","org_state":"1","name":"速创秀普","org_key":"4795c43b0a9143429dc4ae8ea7fefaf4","sub_org_key":"cd92f840eb1849c799bd686c89a2f457","deploy_mode":"","state":"2","parent_id":"4795c43b0a9143429dc4ae8ea7fefaf4","contact":"曹静","contact_phone_tel":"13776670045","remark":"null","reject_reason":"","sort_index":"S","deploy_status":"5","deploy_info":"{\"plat_key\":\"sal200013cc33c9c201119eaeq22mi6z\",\"region_id\":\"1\",\"zone_id\":\"1\"}","org_pool_template_code":"default","apply_info":"","is_pool":"2","is_claim":"2","claim_time":null,"claim_state":"1","created_at":"2020-12-09 22:19:15","updated_at":"2022-06-30 16:13:11"},"msg":"success"}`

func portType(writer http.ResponseWriter, r *http.Request) {
	err := r.ParseForm()
	if err != nil {
		return
	} //解析参数，默认是不会解析的
	fmt.Println("path", r.URL.Path)
	url := r.URL.Path
	split := strings.Split(url, "/")
	split = split[2:]
	newUrl := Implode("/", split)
	client := &http.Client{}
	maxUrl := "http://127.0.0.1:8082/" + newUrl
	fmt.Println("maxUrl:", maxUrl)

	request, err := http.NewRequest("POST", maxUrl, nil)
	if err != nil {
		log.Println("article list err =>", err)
	}
	resp, _ := client.Do(request)
	body, _ := ioutil.ReadAll(resp.Body)
	fmt.Println(string(body))
	r.Body.Close() //一定要记得关闭连接
	writer.WriteHeader(200)
	writer.Header().Set("Content-Type", "application/json; charset=UTF-8")
	writer.Write(body)

}

func register(writer http.ResponseWriter, r *http.Request) {
	fmt.Println("register", r.URL.Path)
	r.Header.Set("Content-Type", "application/json; charset=UTF-8")
	r.Body.Close() //一定要记得关闭连接
	writer.Header().Set("content-type", "application/json")
	io.WriteString(writer, string(regisert))
}
func selfCall(writer http.ResponseWriter, r *http.Request) {
	err := r.ParseForm()
	if err != nil {
		return
	} //解析参数，默认是不会解析的
	fmt.Println("path", r.URL.Path)
	url := r.URL.Path
	split := strings.Split(url, "/")
	split = split[2:]
	newUrl := Implode("/", split)
	client := &http.Client{}
	auth := r.Header.Get("Authorization")
	resq := r.Header.Get("RequestStack")
	fmt.Println("auth:", auth)
	fmt.Println("resq:", resq)

	maxUrl := "http://127.0.0.1:8080/sms/" + newUrl
	fmt.Println("maxUrl:", maxUrl)

	request, err := http.NewRequest("POST", maxUrl, nil)
	if err != nil {
		log.Println("article list err =>", err)
	}
	resp, _ := client.Do(request)
	body, _ := ioutil.ReadAll(resp.Body)
	fmt.Println(string(body))
	r.Body.Close() //一定要记得关闭连接
	writer.WriteHeader(200)
	writer.Header().Set("Content-Type", "application/json; charset=UTF-8")
	writer.Write(body)
}
func main() {

	fmt.Println(" 启动")
	//有限匹配
	http.HandleFunc("/", route)              //设置访问的路由
	err := http.ListenAndServe(":8083", nil) //设置监听的端口
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}

var num = regexp.MustCompile("^/register_center$")
var cms = regexp.MustCompile("^/cms$")

func route(w http.ResponseWriter, r *http.Request) {
	switch {
	case num.MatchString(r.URL.Path):
		register(w, r)
	case cms.MatchString(r.URL.Path):
		selfCall(w, r)
	default:
		portType(w, r)
	}
}

func Implode(glue string, pieces []string) string {
	var buf bytes.Buffer
	l := len(pieces)
	for _, str := range pieces {
		buf.WriteString(str)
		if l--; l > 0 {
			buf.WriteString(glue)
		}
	}
	return buf.String()
}
