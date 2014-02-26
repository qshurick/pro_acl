<?php
/**
 * Created by PhpStorm.
 * User: aleksandr
 * Date: 26.02.14
 * Time: 23:56
 */

class Acl_Application_Db_AclHierarchy extends Pro_Db_Table {
    protected $_name = "acl_hierarchy";
    protected $_referenceMap = array(
        "Role" => array(
            "columns" => "role_id",
            "refTableClass" => "Acl_Application_Db_AclRoles",
            "refColumns" => "id"
        ),
        "Parent" => array(
            "columns" => "parent_role_id",
            "refTableClass" => "Acl_Application_Db_AclRoles",
            "refColumns" => "id"
        ),
    );

}