(ns orbiter-slack-server.main
  (:gen-class)
  (:use org.httpkit.server))

;; TODO: deploy, config, state, domain, modules

(defn app [req]
  {:status 200
   :headers {"Content-Type" "text/html"}
   :body "hello HTTP!"
   })

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (run-server app {:port 8080}))
