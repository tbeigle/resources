<?php

/**
 * Implements hook_install_tasks_alter().
 */
function dd_profile_install_tasks_alter(&$tasks, $install_state) {
  // Preselect the English language, so users can skip the language selection
  // form. We do not ship other languages at this point.
  if (!isset($_GET['locale'])) {
    $_POST['locale'] = 'en';
  }
}


/**
 * Implements hook_form_FORM_ID_alter().
 *
 * Allows the profile to alter the site configuration form.
 */
function dd_profile_form_install_configure_form_alter(&$form, $form_state) {
  // Pre-populate the site name with the server name.
  $form['site_information']['site_name']['#default_value'] = $_SERVER['SERVER_NAME'];
  $form['site_information']['site_mail']['#default_value'] = 'admin@'. $_SERVER['HTTP_HOST']; 
  $form['admin_account']['account']['name']['#default_value'] = 'admin';
  $form['admin_account']['account']['mail']['#default_value'] = 'admin@'. $_SERVER['HTTP_HOST'];
}
