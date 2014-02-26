<?php
/**
 * Created by PhpStorm.
 * User: aleksandr
 * Date: 27.02.14
 * Time: 1:17
 */

class Acl_Application_AclResource implements Zend_Acl_Resource_Interface {

    protected $_type;
    protected $_rowId;

    public function __construct($type) {
        $this->_type = $type;
    }

    public function setRowId($rowId) {
        $this->_rowId = $rowId;
        return $this;
    }

    public function getRowId() {
        return $this->_rowId;
    }

    public function getType() {
        return $this->_type;
    }

    /* (non-PHPdoc)
     * @see Zend_Acl_Resource_Interface::getResourceId()
     */
    public function getResourceId() {
        return $this->_type;
    }
}