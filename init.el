;; config file
(require 'package)
;; MELPAを追加
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; MELPA-stableを追加
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;; Marmaladeを追加
(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/") t)
;; Orgを追加
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
;; gtagsを追加
(add-to-list 'load-path "/usr/local/share/gtags")
;; 初期化
;;(package-initialize)

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-display-errors-delay 0.5)
 '(flycheck-display-errors-function
   (lambda
     (errors)
     (let
         ((messages
           (mapcar
            (function flycheck-error-message)
            errors)))
       (popup-tip
        (mapconcat
         (quote identity)
         messages "
")))))
 '(irony-additional-clang-options (quote ("-std=c++17")))
 '(package-selected-packages
   (quote
    (rust-mode flycheck-pos-tip flycheck-popup-tip flycheck-irony flycheck markdown-mode google-c-style haskell-mode protobuf-mode company-jedi company-php php-mode dumb-jump company counsel yasnippet neotree magit))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'popup)

;;gtags
(autoload 'gtags-mode "gtags" "" t)
(setq gtags-mode-hook
    '(lambda ()
        (local-set-key "\M-t" 'gtags-find-tag)    ;関数へジャンプ
        (local-set-key "\M-r" 'gtags-find-rtag)   ;関数の参照元へジャンプ
        (local-set-key "\M-s" 'gtags-find-symbol) ;変数の定義元/参照先へジャンプ
        (local-set-key "\C-t" 'gtags-pop-stack)   ;前のバッファに戻る
        ))

(add-hook 'c-mode-hook 'gtags-mode)
(add-hook 'c++-mode-hook 'gtags-mode)

;;yasnippet
(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/mysnippets"
        "~/.emacs.d/yasnippets/snippets"
        ))

;; 既存スニペットを挿入する
(define-key yas-minor-mode-map (kbd "C-x i i") 'yas-insert-snippet)
;; 新規スニペットを作成するバッファを用意する
(define-key yas-minor-mode-map (kbd "C-x i n") 'yas-new-snippet)
;; 既存スニペットを閲覧・編集する
(define-key yas-minor-mode-map (kbd "C-x i v") 'yas-visit-snippet-file)

(yas-global-mode 1)

;;ivy
(require 'ivy)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(setq ivy-height 30) ;; minibufferのサイズを拡大！（重要）
(setq ivy-extra-directories nil)
(setq ivy-re-builders-alist
      '((t . ivy--regex-plus)))

;; counsel設定
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file) ;; find-fileもcounsel任せ！
(defvar counsel-find-file-ignore-regexp (regexp-opt '("./" "../")))



;; dumb-jump
(setq dumb-jump-mode t)
(setq dumb-jump-selector 'ivy) ;; 候補選択をivyに任せます
(setq dumb-jump-use-visible-window nil)
(global-set-key (kbd "M-.") 'dumb-jump-go) ;; go-to-definition!
(global-set-key (kbd "M-]") 'dumb-jump-back) ;; go-to-definition!



;; company
(require 'company)
(global-company-mode) ; 全バッファで有効にする
(setq company-transformers '(company-sort-by-backend-importance)) ;; ソート順
(setq company-idle-delay 0) ; デフォルトは0.5
(setq company-minimum-prefix-length 3) ; デフォルトは4
(setq company-selection-wrap-around t) ; 候補の一番下でさらに下に行こうとすると一番上に戻る
(setq completion-ignore-case t)
(setq company-dabbrev-downcase nil)
(global-set-key (kbd "C-M-i") 'company-complete)
(define-key company-active-map (kbd "C-n") 'company-select-next) ;; C-n, C-pで補完候補を次/前の候補を選択
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-search-map (kbd "C-n") 'company-select-next)
(define-key company-search-map (kbd "C-p") 'company-select-previous)
(define-key company-active-map (kbd "C-s") 'company-filter-candidates) ;; C-sで絞り込む
(define-key company-active-map (kbd "C-i") 'company-complete-selection) ;; TABで候補を設定
(define-key company-active-map [tab] 'company-complete-selection) ;; TABで候補を設定
(define-key company-active-map (kbd "C-f") 'company-complete-selection) ;; C-fで候a補を設定
(define-key emacs-lisp-mode-map (kbd "C-M-i") 'company-complete) ;; 各種メジャーモードでも C-M-iで company-modeの補完を使う

;; yasnippetとの連携
(defvar company-mode/enable-yas t
  "Enable yasnippet for all backends.")
(defun company-mode/backend-with-yas (backend)
  (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
      backend
    (append (if (consp backend) backend (list backend))
            '(:with company-yasnippet))))
(setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))




;;counsel-recentf
;; 余分なメッセージを削除しておきましょう
(defmacro with-suppressed-message (&rest body)
  "Suppress new messages temporarily in the echo area and the `*Messages*' buffer while BODY is evaluated."
  (declare (indent 0))
  (let ((message-log-max nil))
    `(with-temp-message (or (current-message) "") ,@body)))

(require 'recentf)
(setq recentf-save-file "~/.emacs.d/.recentf")
(setq recentf-max-saved-items 200)             ;; recentf に保存するファイルの数
(setq recentf-exclude '(".recentf"))           ;; .recentf自体は含まない
(setq recentf-auto-cleanup 'never)             ;; 保存する内容を整理
(run-with-idle-timer 30 t '(lambda () (with-suppressed-message (recentf-save-list))))
(require 'recentf-ext) ;; ちょっとした拡張

(define-key global-map [(super r)] 'counsel-recentf) ;; counselにおまかせ！



;;php-mode
(require 'php-mode)

;;company-php
(add-hook 'php-mode-hook
          '(lambda ()
             (require 'company-php)
             (company-mode t)
             (ac-php-core-eldoc-setup) ;; enable eldoc
             (make-local-variable 'company-backends)
             (add-to-list 'company-backends 'company-ac-php-backend)))

;;magit
(global-set-key (kbd "C-x g") 'magit-status)

;;neotree
(require 'all-the-icons)
(require 'neotree)
;; 隠しファイルをデフォルトで表示
(setq neo-show-hidden-files t)
;; cotrol + q でneotreeを起動
(global-set-key "\C-t" 'neotree-toggle)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))


(require 'epc)
(require 'python)

;;jedi
(require 'jedi-core)
(setq jedi:complete-on-dot t)
(setq jedi:use-shortcuts t)
(add-hook 'python-mode-hook 'jedi:setup)
(add-to-list 'company-backends 'company-jedi) ; backendに追加


;;else
(global-linum-mode t)



;;hs-minor-mode
(add-hook 'c++-mode-hook                                                                                                                                                                                                      '(lambda ()                                                                                                                                                                                                                         
             (hs-minor-mode 1)))                                                                                                                                                                                                              
(add-hook 'c-mode-hook                                                                                                                                                                                                                        
          '(lambda ()                                                                                                                                                                                                                         
             (hs-minor-mode 1)))                                                                                                                                                                                                              
(add-hook 'scheme-mode-hook                                                                                                                                                                                                                   
          '(lambda ()                                                                                                                                                                                                                         
             (hs-minor-mode 1)))                                                                                                                                                                                                              
(add-hook 'emacs-lisp-mode-hook                                                                                                                                                                                                               
          '(lambda ()                                                                                                                                                                                                                         
             (hs-minor-mode 1)))                                                                                                                                                                                                              
(add-hook 'lisp-mode-hook                                                                                                                                                                                                                     
          '(lambda ()                                                                                                                                                                                                                         
             (hs-minor-mode 1)))                                                                                                                                                                                                              
(add-hook 'python-mode-hook                                                                                                                                                                                                                   
          '(lambda ()                                                                                                                                                                                                                         
             (hs-minor-mode 1)))                                                                                                                                                                                                              
(add-hook 'ruby-mode-hook                                                                                                                                   '(lambda ()                                                                                                                                          (hs-minor-mode 1)))                                                                                                                  
(define-key global-map (kbd "C-\\") 'hs-toggle-hiding)


;;protobuf-mode
(require 'protobuf-mode)


;;google-c-style
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

;; markdown-mode
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)


;;irony-mode
(eval-after-load "irony"
  '(progn
     (custom-set-variables '(irony-additional-clang-options '("-std=c++17")))
     (add-to-list 'company-backends 'company-irony)
     (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
     (add-hook 'c-mode-common-hook 'irony-mode)))

;;flycheck
(when (require 'flycheck nil 'noerror)
  (custom-set-variables
   ;; エラーをポップアップで表示
   '(flycheck-display-errors-function
     (lambda (errors)
       (let ((messages (mapcar #'flycheck-error-message errors)))
         (popup-tip (mapconcat 'identity messages "\n")))))
   '(flycheck-display-errors-delay 0.5))
  (define-key flycheck-mode-map (kbd "C-M-n") 'flycheck-next-error)
  (define-key flycheck-mode-map (kbd "C-M-p") 'flycheck-previous-error)
  (add-hook 'c-mode-common-hook 'flycheck-mode))

;;flycheck-irony
(eval-after-load "flycheck"
  '(progn
     (when (locate-library "flycheck-irony")
       (flycheck-irony-setup))))

;;C++ style
(setq-default c-basic-offset 4     ;;基本インデント量4
              tab-width 4          ;;タブ幅4
               indent-tabs-mode nil)  ;;インデントをタブでするかスペースでするか
(add-hook 'c++-mode-hook
          '(lambda()
             (c-set-style "stroustrup")
             (c-set-offset 'innamespace 4)   ; namespace {}の中はインデントしない
             (c-set-offset 'arglist-close 0) ; 関数の引数リストの閉じ括弧はインデントしない
             ))

(with-eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook 'flycheck-popup-tip-mode))
