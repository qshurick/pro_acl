<?php
/**
 * Created by PhpStorm.
 * User: aleksandr
 * Date: 26.02.14
 * Time: 23:37
 */

class Acl_Application_Resource_Acl extends Zend_Application_Resource_ResourceAbstract {
    /**
     * Strategy pattern: initialize resource
     *
     * @return mixed
     */
    public function init() {
        $this->getBootstrap()->bootstrap('logger');
        $acl = Acl_Application_Acl::getInstance();
        Zend_Registry::set(Acl_Application_Acl::REGISTER_ALIAS, $acl);
    }

}