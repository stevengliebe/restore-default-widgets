<?php
/**
 * Plugin Name: Restore Default Widgets
 * Plugin URI: https://github.com/stevengliebe/restore-default-widgets
 * Description: Restores default WordPress widgets unregistered by themes and plugins.
 * Version: 1.0.1
 * Author: Steven Gliebe
 * Author URI: http://stevengliebe.com
 * License: http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
 */

// No direct access
if ( ! defined( 'ABSPATH' ) ) exit;

/**
 * Register default widgets
 *
 * This repeats the registering that wp_widgets_init() does.
 * 
 * @since 1.0
 */
function rdw_register_widgets() {

	register_widget( 'WP_Widget_Pages' );

	register_widget( 'WP_Widget_Calendar' );

	register_widget( 'WP_Widget_Archives' );

	if ( get_option( 'link_manager_enabled' ) ) {
		register_widget( 'WP_Widget_Links' );
	}

	register_widget( 'WP_Widget_Meta' );

	register_widget( 'WP_Widget_Search' );

	register_widget( 'WP_Widget_Text' );

	register_widget( 'WP_Widget_Categories' );

	register_widget( 'WP_Widget_Recent_Posts' );

	register_widget( 'WP_Widget_Recent_Comments' );

	register_widget( 'WP_Widget_RSS' );

	register_widget( 'WP_Widget_Tag_Cloud' );

	register_widget( 'WP_Nav_Menu_Widget' );

}

add_action( 'widgets_init', 'rdw_register_widgets', 99 ); // likely after unregistering (note: http://10up.com/blog/watch-those-hook-priorities/)
