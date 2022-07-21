<?php
/**
 * Plugin Name: Thank after post plugin
 * Plugin URI: http://www.mywebsite.com/thank-after-post
 * Description: Plugin that adds thank you after all posts
 * Version: 1.0.0
 * Author: John Snow
 * Author URI: http://www.mywebsite.com
 */
add_action( 'the_content', 'thank_after_post' );

function thank_after_post ( $content ) {
    return $content .= '<p>Спасибо за просмотр!<br>v 1.0.0</p>';
}
