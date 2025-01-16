;;; publish.el --- Generate Static HTML -*- lexical-binding: t -*-
;;
;; Author: Lincoln Clarete <lincoln@clarete.li>
;;
;; Copyright (C) 2020  Lincoln Clarete
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;
;;; Commentary:
;;
;; How my blog is generated
;;
;;; Code:

;; Initialize packaging system
(require 'package)
(package-initialize)
(add-to-list
 'package-archives
 '("melpa" . "http://melpa.org/packages/"))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Install dependencies
(use-package htmlize :config :ensure t)
(use-package rainbow-delimiters :config :ensure t)

;; Configure dependencies
(require 'ox-html)
(require 'weblorg)


(delete-directory "blog/" t)
(make-directory "blog/")
(copy-directory "static-files/" "blog/static")

;; Output HTML with syntax highlight with css classes instead of
;; directly formatting the output.
(setq org-html-htmlize-output-type 'css)
(setq org-export-with-broken-links nil)

;; Static site generation
(setq weblorg-default-url "https://klovanych.org")

(weblorg-route
 :name "index"
 :input-pattern "index.org"
 :template "index.html"
 :output "blog/index.html"
 :url "/")

(weblorg-route
 :name "posts"
 :input-pattern "posts/*.org"
 :template "post.html"
 :output "blog/posts/{{ slug }}.html"
 :url "/posts/{{ slug }}.html")

(weblorg-route
 :name "about"
 :input-pattern "website-pages/about.org"
 :template "index.html"
 :output "blog/about.html"
 :url "/about.html")

(weblorg-route
 :name "rss"
 :input-pattern "posts/*.org"
 :input-aggregate #'weblorg-input-aggregate-all-desc
 :template "rss.xml"
 :output "blog/rss.xml"
 :url "/rss.xml")

(weblorg-route
 :name "blog"
 :input-pattern "posts/*.org"
 :input-aggregate #'weblorg-input-aggregate-all-desc
 :template "blog.html"
 :output "blog/index.html"
 :url "/blog")

(setq debug-on-error t)

(weblorg-export)

;;; publish.el ends here
