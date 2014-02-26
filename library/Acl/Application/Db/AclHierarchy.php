<?php
/**
 * Created by PhpStorm.
 * User: aleksandr
 * Date: 26.02.14
 * Time: 23:56
 */

class Acl_Application_Db_AclHierarchy extends Pro_Db_Table {
    protected $_name = "acl_hierarchy";
    protected $_primary = array("role_id", "parent_role_id");
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

    public function ensureParents($roleId, $parents = array()) {
        if (!empty($parents)) {
            foreach ($parents as $parentRoleId) {
                $this->insert(array(
                    'role_id' => $roleId,
                    'parent_role_id' => $parentRoleId,
                ));
            }
        }
    }
}