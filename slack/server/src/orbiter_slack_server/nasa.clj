(ns orbiter-slack-server.nasa
  (:require
   [clojure.string :as str]
   [org.httpkit.client :as http]
   [clojure.data.json :as json]))

(defn get-apod []
  (let [resp @(http/get
                 "https://api.nasa.gov/planetary/apod"
                 {:insecure? true
                  :query-params {:api_key "DEMO_KEY"}})]
    (json/read-str (:body resp) :key-fn keyword)))
