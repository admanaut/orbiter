(ns orbiter-slack-server.slack
  (:use [orbiter-slack-server.nasa :as nasa]
        [compojure.core :as cj :only [POST]]
        [ring.middleware.params :only [wrap-params]]
        [clojure.data.json :as json]
        [clojure.string :as str]))

(defn expl-block [title explanation]
  {:type "section"
   :text {:type "mrkdwn"
          :text (str/join ["*" title "*" " " explanation])
          }
   })

(defn img-block [alt url]
  {:type "image"
   :title {:type "plain_text"
           :text alt
           }
   :block_id "image4"
   :image_url url
   :alt_text alt
   })

(defn ctx-block [date copyright]
  (-> (str/join ["*Date:* " date])
      ((fn [t] (if copyright (str/join [t ", *Copyright:* " copyright]) t)))
      ((fn [t] {:type "context" :elements [{:type "mrkdwn" :text t}]})))
  )

(defn blocks [& blocks] {:blocks blocks})

(defn response [body]
  {:status 200
   :headers {"Content-Type" "application/json"}
   :body body
   })

(defn handle-apod [params]
  (if (empty? params)
    (let [{:keys [title explanation date url copyright] :as resp} (nasa/get-apod)]
      (response
        (json/write-str
          (blocks
            (expl-block title explanation)
            (img-block title url)
            (ctx-block date copyright)))))
    (response "apod for date")))

(def handle-help
  (response "Welcome to Orbiter! Here's what you can do next: TODO"))

;; slack sends us what the user typed after the
;; slash command as plain text, so we need to
;; tokenise it and interpret the tokens
(defn dispatch-command [r text]
  (let [[app & params] (-> text str/trim (str/split #" "))]
    (do
      (cond
        (= app "apod") (handle-apod params)
        :else           handle-help))))

(def slack-routes
  (cj/routes
    (POST "/" [text :as r] (dispatch-command r text))))
