(ns orbiter-slack-server.config
  (:use [orbiter-slack-server.validation :as v]))

(defn get-config []
  (v/map-v (fn [i] {:port i}) (isNotNil (get (System/getenv) "PORT") "Env var PORT is required")))
