(ns orbiter-slack-server.main
  (:gen-class)
  (:use [org.httpkit.server :as httpkit]
        [orbiter-slack-server.config :as config]
        [orbiter-slack-server.validation :as v]
        [compojure.route :only [files not-found]]
        [compojure.core :only [defroutes GET POST]]
        [clojure.data.json :as json]
        ))

;; TODO: config, state, domain, modules

(defn handle-help [req]
  (do
    (println req)
    (println (slurp (:body req)))
    {:status 200
     :headers {"Content-Type" "text/html"}
     :body "Welcome to Orbiter! here's what you can do next:"
     }))

(defroutes app
  (GET "/" [] handle-help)
  (POST "/" [] handle-help)
  (files "/static/")
  (not-found "Page not found."))

(defn -main [& args]
  (let [confv (config/get-config)
        conf (v/run-v confv)]
    (if (v/isSuccess confv)
      (do
        (println "Server started on port " (:port conf))
        (httpkit/run-server app {:port (:port conf)}))
      (do
        (println conf)
        (System/exit 1)))))
