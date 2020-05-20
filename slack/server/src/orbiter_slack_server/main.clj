(ns orbiter-slack-server.main
  (:gen-class)
  (:use [org.httpkit.server :as httpkit]
        [orbiter-slack-server.config :as config]
        [orbiter-slack-server.validation :as v]))

;; TODO: config, state, domain, modules

(defn app [req]
  (do
    (println req)
    {:status 200
     :headers {"Content-Type" "text/html"}
     :body "hello HTTP!"
     }))

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
