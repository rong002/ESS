;;; essd-vst.el --- ARC customization

;; Copyright (C) 2000 A. J. Rossini

;; Author: A.J. Rossini <rossini@stat.sc.edu>
;; Maintainer: A.J. Rossini <rossini@stat.sc.edu>
;; Created: 30 Jun 2000
;; Modified: $Date: 2001/08/08 19:25:07 $
;; Version: $Revision: 1.5 $
;; RCS: $Id: essd-arc.el,v 1.5 2001/08/08 19:25:07 ess Exp $
;;
;; Keywords: start up, configuration.

;; This file is part of ESS

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:
;;; This file extends the XLispStat configuration for ARC, the
;;; extension of the R-Code.
;;;

;;; Requires and Autoloads:

(require 'essl-lsp)

(autoload 'inferior-ess "ess-inf" "Run an ESS process.")

;;; Code:

(defvar ARC-customize-alist
  '((ess-customize-alist           .  ARC-customize-alist )
    (ess-language                  .  "XLS"               )
    (ess-dialect                   .  "ARC"               )
    (ess-loop-timeout              .  50000               )
    (ess-object-name-db-file       .  "ess-xls-namedb.el" )
    (ess-help-sec-regex            .  " ")
    (ess-help-sec-keys-alist       .  " ")
    (inferior-ess-primary-prompt   .  "> ?"               )
    (comint-use-prompt-regexp-instead-of-fields . t) ;; emacs 21 and up
    (inferior-ess-program          .  inferior-ARC-program-name)
    (inferior-ess-help-command     .  "(help '%s)\n"      )
    (inferior-ess-objects-command  .  "(variables)\n"     )
    (inferior-ess-exit-command     .  "(exit)\n"          )
    ;;(inferior-ess-start-args       . nil)
    (inferior-ess-start-file       .  nil)) ; "~/.ess-ARC")

  "Variables to customize for ARC, a dialect of XLS.")


(defun ARC-mode (&optional proc-name)
  "Major mode for editing ARC source.  NOT EVEN STARTED."
  (interactive)
  (setq ess-customize-alist ARC-customize-alist)
  (lisp-mode))


(defun ARC ()
  "Call 'ARC', the extend XLispStat statistical system, from Forrest Young."

  (interactive)
  (setq ess-customize-alist ARC-customize-alist)
  (ess-write-to-dribble-buffer
   (format "(ARC): ess-dialect=%s , buf=%s\n"
  	   ess-dialect (current-buffer)))
  (inferior-ess))

(fset 'arc 'ARC)

 ; Provide package

(provide 'essd-arc)

 ; Local variables section

;;; This file is automatically placed in Outline minor mode.
;;; The file is structured as follows:
;;; Chapters:     ^L ;
;;; Sections:    ;;*;;
;;; Subsections: ;;;*;;;
;;; Components:  defuns, defvars, defconsts
;;;              Random code beginning with a ;;;;* comment

;;; Local variables:
;;; mode: emacs-lisp
;;; outline-minor-mode: nil
;;; mode: outline-minor
;;; outline-regexp: "\^L\\|\\`;\\|;;\\*\\|;;;\\*\\|(def[cvu]\\|(setq\\|;;;;\\*"
;;; End:

;;; ess-site.el ends here
