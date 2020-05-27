(ns orbiter-slack-server.slack
  (:use [compojure.core :as cj :only [POST]]
        [ring.middleware.params :only [wrap-params]]
        [clojure.data.json :as json]
        [clojure.string :as str]))

(def apod-today
  {:blocks
   [{:type "section"
     :text {:type "mrkdwn"
            :text "*A Message from Earth* What are these Earthlings trying to tell us?  The featured message was broadcast from Earth towards the globular star cluster M13 in 1974.  During the dedication of the Arecibo Observatory - still one of the largest single radio telescopes in the world - a string of 1's and 0's representing the diagram was sent.   This attempt at extraterrestrial communication was mostly ceremonial - humanity regularly broadcasts radio and television signals out into space accidentally.  Even were this message received, M13 is so far away we would have to wait almost 50,000 years to hear an answer.   The featured message gives a few simple facts about humanity and its knowledge: from left to right are numbers from one to ten, atoms including hydrogen and carbon, some interesting molecules, DNA, a human with description, basics of our Solar System, and basics of the sending telescope.  Several searches for extraterrestrial intelligence are currently underway, including one where you can use your own home computer.    Experts Debate: How will humanity first discover ET life?"
              }
     }
    {:type "image"
     :title {:type "plain_text"
             :text "A Message from Earth"
             }
     :block_id "image4"
     :image_url "https://apod.nasa.gov/apod/image/2005/Message_Arecibo_2000.jpg"
     :alt_text "A Message from Earth"
     }
    ]
   })

(defn handle-apod [params]
  (if (empty? params)
    {:status 200
     :headers {"Content-Type" "text/json"}
     :body (json/write-str apod-today)
     }
    {:status 200
     :headers {"Content-Type" "text/json"}
     :body "apod for date"
     }
    )
  )

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
