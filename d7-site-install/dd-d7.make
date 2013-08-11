; Designated Developers Make File
; Version 7.x-dev

api = 2

; Core version
; ------------
; Each makefile should begin by declaring the core version of Drupal that all
; projects should be compatible with.

core = 7.x

; Core project
; ------------
; In order for your makefile to generate a full Drupal site, you must include
; a core project. This is usually Drupal core, but you can also specify
; alternative core projects like Pressflow. Note that makefiles included with
; install profiles *should not* include a core project.
; 

projects[drupal][type] = core

; Modules
; --------
; Each project that you would like to include in the makefile should be
; declared under the `projects` key.

; Core/APIs
projects[ctools][subdir] = "contrib"
projects[date][subdir] = "contrib"
projects[job_scheduler][subdir] = "contrib"
projects[token][subdir] = "contrib"

; Content Editing
projects[better_formats][subdir] = "contrib"
projects[metatag][subdir] = "contrib"
projects[wysiwyg][subdir] = "contrib"
projects[imagecrop][subdir] = "contrib"
projects[imce][subdir] = "contrib"
projects[imce_mkdir][subdir] = "contrib"
projects[imce_wysiwyg][subdir] = "contrib"
projects[webform][subdir] = "contrib"
projects[field_collection][subdir] = "contrib"

; Entities & Fields
projects[disable_term_node_listings][subdir] = "contrib"
projects[email][subdir] = "contrib"
projects[entity][subdir] = "contrib"
projects[entityreference][subdir] = "contrib"
projects[field_group][subdir] = "contrib"
projects[filefield_sources][subdir] = "contrib"
projects[link][subdir] = "contrib"
projects[taxonomy_formatter][subdir] = "contrib"

; Menus
projects[menu_attributes][subdir] = "contrib"
projects[menu_block][subdir] = "contrib"
projects[menu_item_visibility][subdir] = "contrib"
projects[menu_position][subdir] = "contrib"
projects[taxonomy_menu][subdir] = "contrib"

; Blocks
projects[block_class][subdir] = "contrib"
projects[blocktheme][subdir] = "contrib"
projects[block_titlelink][subdir] = "contrib"
projects[boxes][subdir] = "contrib"
projects[quicktabs][subdir] = "contrib"

; Views
projects[views][subdir] = "contrib"
projects[eva][subdir] = "contrib"
projects[views_bulk_operations][subdir] = "contrib"
projects[views_field_view][subdir] = "contrib"
projects[views_random_seed][subdir] = "contrib"
projects[views_ui_basic][subdir] = "contrib"
projects[views_natural_sort][subdir] = "contrib"

; Misc.
projects[addanother][subdir] = "contrib"
projects[advanced_help][subdir] = "contrib"
projects[admin_menu][subdir] = "contrib"
projects[admin_views][subdir] = "contrib"
projects[auto_nodetitle][subdir] = "contrib"
projects[backup_migrate][subdir] = "contrib"
projects[calendar][subdir] = "contrib"
projects[captcha][subdir] = "contrib"
projects[colorbox][subdir] = "contrib"
projects[context][subdir] = "contrib"
projects[context_disable_context][subdir] = "contrib"
projects[custom_search][subdir] = "contrib"
projects[date_ical][subdir] = "contrib"
projects[diff][subdir] = "contrib"
projects[environment_indicator][subdir] = "contrib"
projects[fast_404][subdir] = "contrib"
projects[features][subdir] = "contrib"
projects[feeds][subdir] = "contrib"
projects[globalredirect][subdir] = "contrib"
projects[google_analytics][subdir] = "contrib"
projects[jquery_update][subdir] = "contrib"
projects[login_destination][subdir] = "contrib"
projects[logintoboggan][subdir] = "contrib"
projects[module_filter][subdir] = "contrib"
projects[nodeblock][subdir] = "contrib"
projects[node_clone][subdir] = "contrib"
projects[nodequeue][subdir] = "contrib"
projects[override_node_options][subdir] = "contrib"
projects[pathauto][subdir] = "contrib"
projects[rules][subdir] = "contrib"
projects[redirect][subdir] = "contrib"
projects[strongarm][subdir] = "contrib"
projects[transliteration][subdir] = "contrib"
projects[xmlsitemap][subdir] = "contrib"

; Development
projects[coder][subdir] = "contrib"
projects[css_injector][subdir] = "contrib"
projects[devel][subdir] = "contrib"
projects[js_injector][subdir] = "contrib"
projects[masquerade][subdir] = "contrib"
projects[search_krumo][subdir] = "contrib"
projects[token_tweaks][subdir] = "contrib"

; Libraries
; --------

projects[libraries][subdir] = "contrib"
libraries[ckeditor][download][type] = "svn"
libraries[ckeditor][download][url] = "http://svn.ckeditor.com/CKEditor/releases/stable/"
libraries[ckeditor][directory_name] = "ckeditor"

; Themes
; --------

; Modules that need testing, but aren't necessary for current build
; --------

; Modules without D7 releases
; --------
