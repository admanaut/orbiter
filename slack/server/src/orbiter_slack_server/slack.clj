(ns orbiter-slack-server.slack
  (:use [compojure.core :as cj :only [POST]]
        [ring.middleware.params :only [wrap-params]]
        [clojure.data.json :as json]
        [clojure.string :as str]))

(defn handle-apod [params]
  {:status 200
   :headers {"Content-Type" "text/html"}
   :body ""
   })

(def handle-help
  (do
    {:status 200
     :headers {"Content-Type" "text/html"}
     :body "Welcome to Orbiter! Here's what you can do next:"
     }))

;; slack sends us what the user typed after the
;; slash command as plain text, so we need to
;; tokenise it and interpret the tokens
(defn dispatch-command [r text]
  (let [[app & params] (-> text str/trim (str/split #" "))]
    (do
      (println r)
      (println app)
      (println params)
      (cond
        (= app "apod") (handle-apod params)
        :else           handle-help))))

(def slack-routes
  (cj/routes
    (POST "/" [text :as r] (dispatch-command r text))))
