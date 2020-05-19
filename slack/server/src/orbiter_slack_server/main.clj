(ns orbiter-slack-server.main
  (:gen-class)
  (:use [org.httpkit.server :as httpkit]
        [orbiter-slack-server.config :as config]
        [orbiter-slack-server.validation :as v]))

;; TODO: deploy, config, state, domain, modules

(defn app [req]
  {:status 200
   :headers {"Content-Type" "text/html"}
   :body "hello HTTP!"
   })

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (let [confv (config/get-config)
        conf (v/run-v confv)]
    (if (v/isSuccess confv)
      (httpkit/run-server app {:port (:port conf)})
      (do
        (println conf)
        (System/exit 1)))))
