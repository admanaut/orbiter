(defproject orbiter-slack-server "0.1.0-SNAPSHOT"
  :description "Server API serving the Orbiter Slack App"
  :url ""
  :license {:name "EPL-2.0 OR GPL-2.0-or-later WITH Classpath-exception-2.0"
            :url "https://www.eclipse.org/legal/epl-2.0/"}
  :dependencies [[org.clojure/clojure "1.10.1"]
                 [http-kit "2.3.0"]
                 [compojure "1.6.1"]
                 [org.clojure/data.json "1.0.0"]]
  :main ^:skip-aot orbiter-slack-server.main
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})
