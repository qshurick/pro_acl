<?php
/**
 * Created by PhpStorm.
 * User: aleksandr
 * Date: 27.02.14
 * Time: 0:02
 */

class Acl_Application_Db_AclUser extends Pro_Db_Table {
    protected $_name = "acl_user";
    protected $_referenceMap = array(
        "Role" => array(
            "columns" => "role_id",
            "refTableClass" => "Acl_Application_Db_AclRoles",
            "refColumns" => "id"
        ),
    );
}