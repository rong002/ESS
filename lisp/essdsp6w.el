;;; essdsp6w.el --- S-PLUS 6.x  for Windows customization
;;; copied and edited from essd-sp4.el
;;; Richard M. Heiberger, April 2001

;; Copyright (C) 2001 Richard M. Heiberger <rmh@sbm.temple.edu>

;; Author: Richard M. Heiberger <rmh@sbm.temple.edu>
;; Maintainer: Richard M. Heiberger <rmh@sbm.temple.edu>
;; Created: April 2001
;; Modified: $Date: 2001/08/08 19:25:07 $
;; Version: $Revision: 5.4 $
;; RCS: $Id: essdsp6w.el,v 5.4 2001/08/08 19:25:07 ess Exp $
;;
;; Keywords: start up, configuration.

;; This file is part of ESS.

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
;;; 
;;; This file defines all the S-PLUS 6.x for Windows customizations
;;; for ess-mode with ddeclient.

;;; Requires and Autoloads:

(require 'essl-s)
(require 'ess-iw32)

(autoload 'inferior-ess "ess-inf" "Run an ESS process.")
(autoload 'ess-mode     "ess-mode" "Edit an ESS process.")

;;; Code:

(defvar S+6-dialect-name "S+6"
  "Name of 'dialect' for S-PLUS 6.x.
Easily changeable in a user's `.emacs'.")

(defvar inferior-S+6-multipleinstances "/MULTIPLEINSTANCES"
  "Default \"/MULTIPLEINSTANCES\" opens up a new instance of S+6 in a
GUI window and connects it to the *S+6 ddeclient* window.  The
alternative nil uses an existing S+6 GUI (if there is one) and
connects it to the *S+6 ddeclient* window.")

(defvar S+6-customize-alist
  '((ess-local-customize-alist     . 'S+6-customize-alist)
    (ess-language                  . "S")
    (ess-dialect                   . S+6-dialect-name)
    (ess-suffix                    . "S")
    (ess-dump-filename-template    . (concat (user-login-name)
					     ".%s."
					     ess-suffix))
    (ess-mode-editing-alist        . S-editing-alist)
    (ess-mode-syntax-table         . S-syntax-table)
    (ess-help-sec-regex            . ess-help-S+-sec-regex)
    (ess-help-sec-keys-alist       . S+-help-sec-keys-alist)
    (ess-loop-timeout              . 500000 )
    (ess-object-name-db-file       . "ess-sp4-namedb.el" )
    (ess-retr-lastvalue-command
     . ".Last.value <- get(\".ess.lvsave\",frame=0)\n")
    (ess-save-lastvalue-command
     . "assign(\".ess.lvsave\",.Last.value,frame=0)\n")
    (inferior-ess-program          . inferior-S+6-program-name)
;;    (inferior-ess-ddeclient        . "ddeclient")
;;    (inferior-ess-client-name      . "S-PLUS")
;;    (inferior-ess-client-command   . "SCommand")
    (inferior-ess-objects-command  . "objects(%d)\n")
    (inferior-ess-help-command     . "help(\"%s\")\n")
    (inferior-ess-exit-command     . "q()\n")
    (inferior-ess-primary-prompt   . "[a-zA-Z0-9() ]*> ?")
    (inferior-ess-secondary-prompt . "+ ?")
    (comint-use-prompt-regexp-instead-of-fields . t) ;; emacs 21 and up
    (inferior-ess-start-file       . nil) ;"~/.ess-S+6")
    (inferior-ess-start-args       . (concat
				      inferior-S+6-multipleinstances
				      " "
				      inferior-S+6-print-command
				      " S_PROJ="
				      (directory-file-name default-directory))))
 "Variables to customize for S+6")

(defvar Sqpe+6-customize-alist
  '((ess-local-customize-alist     . 'Sqpe+6-customize-alist)
    (ess-language                  . "S")
    (ess-dialect                   . S+6-dialect-name)
    (ess-suffix                    . "S")
    (ess-dump-filename-template    . (concat (user-login-name)
					     ".%s."
					     ess-suffix))
    (ess-mode-editing-alist        . S-editing-alist)
    (ess-mode-syntax-table         . S-syntax-table)
    (ess-help-sec-regex            . ess-help-S+-sec-regex)
    (ess-help-sec-keys-alist       . S+-help-sec-keys-alist)
    (ess-loop-timeout              . 500000 )
    (ess-object-name-db-file       . "ess-sp4-namedb.el" )
    (ess-retr-lastvalue-command
     . ".Last.value <- get(\".ess.lvsave\",frame=0)\n")
    (ess-save-lastvalue-command
     . "assign(\".ess.lvsave\",.Last.value,frame=0)\n")
    (inferior-ess-program          . inferior-Sqpe+6-program-name)
    (inferior-ess-objects-command  . "objects(%d)\n")
    (inferior-ess-help-command     . "help(\"%s\")\n")
    (inferior-ess-exit-command     . "q()\n")
    (inferior-ess-primary-prompt   . "[a-zA-Z0-9() ]*> ?")
    (inferior-ess-secondary-prompt . "+ ?")
    (comint-use-prompt-regexp-instead-of-fields . t) ;; emacs 21 and up
    (inferior-ess-start-file       . nil) ;"~/.ess-S+6")
    (inferior-ess-start-args       . ""))
 "Variables to customize for Sqpe+6.")



;;; There are extra complications in S+6 (compared to S+3) because
;;;
;;; (1) The StatSci supplied Splus.exe doesn't work in an emacs
;;;     buffer.  It works as as a GUI window and we must send commands
;;;     to it through ddeclient.  Nonetheless, we need to give it a
;;;     process name and be sure that that there is a valid running
;;;     process in the *S+6 ddeclient* buffer.  Therefore we create an
;;;     ESS process in the buffer as a placeholder and start a shell
;;;     in the ESS buffer.  From the shell we start Splus.  Once Splus
;;;     finishes initializing and kills the original shell, we start
;;;     another shell.  We have a buffer-local variable
;;;     inferior-ess-ddeclient, initialized to nil.  When there is a
;;;     non-nil value of inferior-ess-ddeclient we send lines to
;;;     inferior-ess-ddeclient rather than to the Splus process.
;;; (2) There is no Splus process running in the *S+6 ddeclient*
;;;     buffer.  Therefore inferior-ess will never see a prompt,
;;;     unless we first change it to the null prompt "^".  Then once
;;;     the process has started, we change it back.
;;; (3) When M-x S+6 starts Splus by a shell command, then Splus is an
;;;     independent process and will be survive if the *S+6 ddeclient*
;;;     buffer is killed (or emacs is quit).  The *S+6 ddeclient* is
;;;     made read-only and a warning is placed in it saying that "You
;;;     can't type anything here."  Actually, if thestandalone Splus
;;;     is killed and the *S+6 ddeclient* is made writable (C-x C-q),
;;;     then *S+6 ddeclient* becomes a shell buffer.
;;;
(defun S+6 (&optional proc-name)
  "Call 'S-PLUS 6.x for Windows', the 'GUI Thing' from StatSci.  Put S-Plus
in an independent MS-Window (Splus persists even if the *S+6 ddeclient*
window is killed in emacs).  Do this by creating a comint process that
calls sh.  Send a shell command in that sh buffer to call Splus.  When
it completes set up a shell as a placeholder in the *S+6 ddeclient*
buffer.  The S-Plus options are correctly set.  In particular, the
S-Plus Commands window is opened if the Options/General
Settings/Startup menu says it should be.  There is a 30 second delay
during startup in which the screen will not be refreshed.  This delay
is here to allow slow disks to start the Splus program."
  (interactive)
  (save-excursion
    (setq ess-customize-alist S+6-customize-alist)
    (ess-write-to-dribble-buffer
     (format "\n(S+6): ess-dialect=%s, buf=%s\n" ess-dialect
	     (current-buffer)))
    (setq ess-customize-alist		; change inferior-ess-program
	  (append ess-customize-alist '((inferior-ess-program   . "sh"))))
    (setq ess-customize-alist		; change inferior-ess-primary-prompt
	  (append ess-customize-alist '((inferior-ess-primary-prompt   . "^"))))
    (setq ess-customize-alist		; change inferior-ess-start-args
	  (append ess-customize-alist '((inferior-ess-start-args   . "-i"))))
    (let ((s-proj (getenv "S_PROJ")))
      (setenv "S_PROJ" (directory-file-name default-directory))
      (inferior-ess)
      (sleep-for 2) ; need to wait, else working too fast!  The Splus
		    ; command in *S+6 ddeclient* should follow the "$"
		    ; prompt.  If not, then increase the sleep-for time!
      (setenv "S_PROJ" s-proj))
    (setq ess-customize-alist S+6-customize-alist)
    (ess-setq-vars-local ess-customize-alist)
;;; the next three lines belong in customize-alist, but can't be there
;;; because of the broken ess-setq-vars-default usage in ess-inf.el
    (setq inferior-ess-ddeclient         "ddeclient")
    (setq inferior-ess-client-name       "S-PLUS")
    (setq inferior-ess-client-command    "SCommand")
;;; end of what belongs in customize-alist
    (setq comint-process-echoes nil)
    (setq comint-input-sender 'comint-simple-send)
    (goto-char (point-max))
    (insert (concat inferior-S+6-program-name " "
		    inferior-ess-start-args)) ; Note: there is no final "&".
    ;; Without the "&", the results of  !system.command  come to *S+6 ddeclient*
    ;; With the "&", the results of  !system.command  in S get lost.
    (inferior-ess-send-input)
    (sleep-for 30) ; Need to wait, else working too fast!
                   ; If the ess-current-process-name doesn't appear in the
       		   ; Splus Commands window increase the sleep-for time!
    (setq ess-local-process-name ess-current-process-name)
    (ess-eval-linewise (concat "#" ess-current-process-name))
    (beginning-of-buffer)
    (insert
     "This is a placeholder buffer.  You can't type anything here.
Use `C-x b RET' to return to your file.\n
Anything sent to this process from an S-mode buffer goes
directly to the associated Splus Commands window.\n
The S-Plus Commands window must be visible.
You may need to open the S-Plus Commands window manually (by clicking on
Splus/Window/Commands Window).\n
Any results of the   !system.command   typed at the S prompt in the
Splus Commands window appear in this buffer.\n\n")
    (goto-char (point-max))		; comint-mode-map makes *S+6 ddeclient*
;;  (use-local-map comint-mode-map)     ;a shell buffer after Splus is finished.
    (set-buffer-process-coding-system 'raw-text-dos 'raw-text-unix)
    (toggle-read-only t)		; force buffer to be read-only
    (setq mode-name "ddeESS")
    (ess-eval-linewise inferior-S+6-editor-pager-command)
    ))




(defun S+6-existing (&optional proc-name)
  "Call 'S-PLUS 6.x for Windows', the 'GUI Thing' from StatSci.  Do so by
finding an existing S-Plus in an independent MS-Window (if there is one) and
set up a *S+6 ddeclient* buffer in emacs.  If there is no existing
S-Plus, then a new one will be opened in the default directory,
usually something like c:/Program Files/spls45se/users/yourname.
If you have a HOME environment variable, it will open it there."
  (interactive)
  (let* ((inferior-S+6-multipleinstances " & # ")) ; Note: there is a final "&".
    ;; Without the "&", there is a core dump.
    ;; With the "&", the results of  !system.command  in S get lost.
    ;; We are picking up an existing S-Plus process for sending to.
    ;; It doesn't know about us, so nothing comes back.
    (S+6 proc-name))
  (save-excursion
    (set-buffer (car (buffer-list)))    ; get the ESS buffer just created
    (toggle-read-only nil)		; permit writing in ESS buffer
    (goto-char (point-max))
    (beginning-of-line)
    (forward-line -1)
    (insert
     "This is S+6-existing.
Results of the   !system.command   typed at the S prompt in the
Splus Commands window blink a DOS window and you won't see them.\n\n")
    (toggle-read-only t)		; restore ESS buffer to be read-only
    ))


;;; There are extra complications in Sqpe+6 (compared to S+3) because
;;; (1) The StatSci supplied Sqpe.exe won't work without SHOME as an
;;;     environment variable and Sqpe does not take command line
;;;     arguments and
;;; (2) Sqpe.exe comes up with options(interactive=F), which means it
;;;     doesn't provide prompts by default, and we must change it to T so
;;;     it will provide prompts.
;;;
(defun Sqpe+6 (&optional proc-name)
  "Call 'Sqpe' from 'S-PLUS 6.x for Windows', the 'Real Thing'  from StatSci."
  (interactive)
  (setq ess-customize-alist Sqpe+6-customize-alist)
  (let* ((shome-nil-p (equal (getenv "SHOME") nil)))
    (if shome-nil-p (setenv "SHOME" inferior-Sqpe+6-SHOME-name))
    (ess-write-to-dribble-buffer
     (format "\n(Sqpe+6): ess-dialect=%s, buf=%s\n" ess-dialect
	     (current-buffer)))
    (setq ess-customize-alist		; change inferior-ess-primary-prompt
	  (append ess-customize-alist '((inferior-ess-primary-prompt   . "^"))))
    (inferior-ess)
    (setq ess-customize-alist Sqpe+6-customize-alist) ; restore i-e-p-p in alist
    (ess-setq-vars-local ess-customize-alist)    ; restore i-e-p-p in buffer
    (setq inferior-ess-prompt                    ; define with correct i-e-p-p
	  ;; Do not anchor to bol with `^'       ; (copied from ess-inf.el)
	  (concat "\\("
		  inferior-ess-primary-prompt
		  "\\|"
		  inferior-ess-secondary-prompt
		  "\\)"))
    (setq comint-prompt-regexp (concat "^" inferior-ess-prompt))
                                                ; define with correct i-e-p-p
    (setq comint-input-sender 'inferior-ess-input-sender)
    (add-hook 'comint-output-filter-functions 'shell-strip-ctrl-m nil t)
    (goto-char (point-max))
    (insert "options(interactive=T)")
    (inferior-ess-send-input)
    (setq mode-name "iESS(Sqpe)")
    (ess-eval-linewise inferior-S+6-editor-pager-command)
    (if shome-nil-p (setenv "SHOME" nil))))



(defun S+6-mode (&optional proc-name)
  "Major mode for editing S+6 source.  See `ess-mode' for more help."
  (interactive)
  (setq ess-customize-alist S+6-customize-alist)
  (ess-mode S+6-customize-alist proc-name)
)


(defun S+6-transcript-mode ()
  "S-PLUS 6.x transcript mode."
  (interactive)
  (ess-transcript-mode S+6-customize-alist))


(defun S+6-msdos (&optional proc-name)
  "Call 'S-PLUS 6.x for Windows', the 'GUI Thing' from StatSci.  Put S-Plus
in an independent MS-Window (Splus persists even if the *S+6 ddeclient*
window is killed in emacs).  Do this by creating a comint process that
calls sh.  Send a shell command in that sh buffer to call Splus.  When
it completes set up a shell as a placeholder in the *S+6 ddeclient*
buffer.  The S-Plus options are correctly set.  In particular, the
S-Plus Commands window is opened if the Options/General
Settings/Startup menu says it should be.  There is a 30 second delay
during startup in which the screen will not be refreshed.  This delay
is here to allow slow disks to start the Splus program."
  (interactive)
  (save-excursion
    (setq ess-customize-alist S+6-customize-alist)
    (ess-write-to-dribble-buffer
     (format "\n(S+6): ess-dialect=%s, buf=%s\n" ess-dialect
	     (current-buffer)))
    (setq ess-customize-alist		; change inferior-ess-program
	  (append ess-customize-alist '((inferior-ess-program
					 . (getenv "COMSPEC")))))
    (setq ess-customize-alist		; change inferior-ess-primary-prompt
	  (append ess-customize-alist '((inferior-ess-primary-prompt   . "^"))))
    (setq ess-customize-alist		; change inferior-ess-start-args
	  (append ess-customize-alist '((inferior-ess-start-args   . ""))))
    (let ((s-proj (getenv "S_PROJ")))
      (setenv "S_PROJ" (directory-file-name default-directory))
      (inferior-ess)
      (sleep-for 2) ; need to wait, else working too fast!  The Splus
		    ; command in *S+6 ddeclient* should follow the "$"
		    ; prompt.  If not, then increase the sleep-for time!
      (setenv "S_PROJ" s-proj))
    (setq ess-customize-alist S+6-customize-alist)
    (ess-setq-vars-local ess-customize-alist)
;;; the next three lines belong in customize-alist, but can't be there
;;; because of the broken ess-setq-vars-default usage in ess-inf.el
    (setq inferior-ess-ddeclient         "ddeclient")
    (setq inferior-ess-client-name       "S-PLUS")
    (setq inferior-ess-client-command    "SCommand")
;;; end of what belongs in customize-alist
    (setq comint-input-sender 'comint-simple-send)
    (setq comint-process-echoes nil)
    (goto-char (point-max))
    (insert (concat inferior-S+6-program-name " "
		    inferior-ess-start-args)) ; Note: there is no final "&".
; Without the "&", the results of  !system.command  come to *S+6 ddeclient*
; With the "&", the results of  !system.command  in S get lost.
    (inferior-ess-send-input)
    (sleep-for 30) ; Need to wait, else working too fast!
                   ; If the ess-current-process-name doesn't appear in the
       		   ; Splus Commands window increase the sleep-for time!
;;; from msdos-minor-mode
  (setq comint-process-echoes t)
  (add-hook 'comint-output-filter-functions 'shell-strip-ctrl-m nil t)
;;; end from msdos-minor-mode
    (setq ess-local-process-name ess-current-process-name)
    (ess-eval-linewise (concat "#" ess-current-process-name))
    (beginning-of-buffer)
    (insert
     "This is a placeholder buffer.  You can't type anything here.
Use 'C-x b RET' to return to your file.\n
Anything sent to this process from an S-mode buffer goes
directly to the associated Splus Commands window.\n
The S-Plus Commands window must be visible.
You may need to open the S-Plus Commands window manually
(by clicking on Splus/Window/Commands Window).\n
There is a 30 second delay when this program starts during which the
emacs screen will be partially blank.\n
Remember to
`q()' from S-Plus and
 then M-x C-q exit from the `*S+6 ddeclient* buffer,
or take the risk of not being able to shut down your computer
and suffering through scandisk.\n
Any results of the   !system.command   typed at the S prompt in the
Splus Commands window (are supposed to) appear in this buffer.\n\n")
    (goto-char (point-max))	       ; comint-mode-map makes *S+6 ddeclient*
    (use-local-map comint-mode-map)    ; a shell buffer after Splus is finished.
    (toggle-read-only t)	       ; force buffer to be read-only
    (setq mode-name "ddeESS")
    (ess-eval-linewise inferior-S+6-editor-pager-command)
    ))

(defun S+6-msdos-existing (&optional proc-name)
  "Call 'S-PLUS 6.x for Windows', the 'GUI Thing' from StatSci.  Do so by
finding an existing S-Plus in an independent MS-Window (if there is one) and
set up a *S+6 ddeclient* buffer in emacs.  If there is no existing
S-Plus, then a new one will be opened in the default directory,
usually something like c:/Program Files/spls45se/users/yourname.
If you have a HOME environment variable, it will open it there."
  (interactive)
  (let* ((inferior-S+6-multipleinstances ""))
    (S+6-msdos proc-name))
  (save-excursion
    (set-buffer (car (buffer-list)))    ; get the ESS buffer just created
    (toggle-read-only nil)		; permit writing in ESS buffer
    (goto-char (point-max))
    (beginning-of-line)
    (forward-line -1)
    (insert
     "This is S+6-msdos-existing.
Results of the   !system.command   typed at the S prompt in the
Splus Commands window blink a DOS window and you won't see them.\n\n")
    (toggle-read-only t)		; restore ESS buffer to be read-only
    ))

 ; Provide package

(provide 'essdsp6w)

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

;;; essdsp6w.el ends here
