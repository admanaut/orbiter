(ns orbiter-slack-server.main
  (:gen-class)
  (:use [orbiter-slack-server.config :as config]
        [orbiter-slack-server.validation :as v]
        [orbiter-slack-server.slack :only [slack-routes]]
        [org.httpkit.server :as httpkit]
        [compojure.route :only [files not-found]]
        [compojure.core :as cj]
        [ring.middleware.params :only [wrap-params]]))

(def base-routes
  (cj/routes
    (files "/static/")
    (not-found "Page not found.")))

;; combine all handlers into one
(def handler
  (cj/routes
    slack-routes
    base-routes))

;; handler and middlewares
(def app
  (-> handler
      wrap-params))

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
