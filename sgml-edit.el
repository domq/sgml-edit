;;; sgml-edit.el --- Additional editing commands for Emacs' SGML mode
;;
;; Copyright (C) 2015 Dominique Quatravaux

;; Author: Dominique Quatravaux <dominique@quatravaux.org>

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


;;;; Commentary:

;; Some features I was missing from the psgml good old days.


;;;; Code:

(require 'pcase)

(defconst sgml-edit-version "0.0.1"
  "Version of the sgml-edit package.")

(defvar sgml-last-split-marker nil
  "Used by sgml-split-element")

(defun sgml-split-element ()
  "Split the current element at point.
If repeated, the containing element will be split before the beginning
of then current element."
  (interactive "*")
  (pcase (car (sgml-lexical-context))
    (`comment 	(insert "-->\n<!-- ")
                (indent-according-to-mode))
    (`cdata 	(insert "]]>\n<![CDATA[")
                (indent-according-to-mode))
    (`pi 	(insert "?>\n<? ")
                (indent-according-to-mode))
    (`jsp 	(insert " %>\n<% ")
                (indent-according-to-mode))
    (`tag       (error "cannot split a tag"))
    (`text
     (if (and sgml-last-split-marker (eq this-command last-command))
         ;; Pretend we re-split from last split point; don't move point.
         (save-excursion
           (goto-char (marker-position sgml-last-split-marker))
           (setq sgml-last-split-marker nil)
           (sgml-split-element))
       (let* ((context (save-excursion (sgml-get-context)))
              (opentag (car (last context)))
              (tagname (sgml-tag-name opentag)))
         (insert "\n</" tagname ">")
         (indent-according-to-mode)
         (setq sgml-last-split-marker (point-marker))
         (insert "\n<" tagname ">")
         (indent-according-to-mode))))
    (_          (error "cannot split here"))))

(provide 'sgml-edit)
