(ns orbiter-slack-server.validation)

;; Validation
;;   {:failure e}
;;   {:success a}

(defn map-v [fnab va]
  (cond
    (contains? va :failure) va
    (contains? va :success) {:success (fnab (:success va))}))

(defn do-v [va vb]
  (cond
    (contains? va :failure) {:failure (concat (:failure va) (:failure vb))}
    (contains? va :success) {:success (merge (:success va) (:success vb))}))

(defn run-v [v]
  (cond
    (contains? v :failure) (:failure v)
    (contains? v :success) (:success v)))

(defn isFailure [v]
  (contains? v :failure))

(defn isSuccess [v]
  (contains? v :success))

(defn isNotNil [a e]
  "Validates that 'a' is not nil"
  (if (nil? a)
    {:failure [e]}
    {:success a}))
