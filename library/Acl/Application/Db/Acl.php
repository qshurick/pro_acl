<?php
/**
 * Created by PhpStorm.
 * User: aleksandr
 * Date: 27.02.14
 * Time: 0:04
 */

class Acl_Application_Db_Acl extends Pro_Db_Table {
    protected $_name = "acl";
    protected $_primary = "id";
    protected $_referenceMap = array(
        "Role" => array(
            "columns" => "id",
            "refTableClass" => "Acl_Application_Db_AclRoles",
            "refColumns" => "id"
        ),
    );
}