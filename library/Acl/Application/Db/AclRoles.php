<?php
/**
 * Created by PhpStorm.
 * User: aleksandr
 * Date: 26.02.14
 * Time: 23:53
 */

class Acl_Application_Db_AclRoles extends Pro_Db_Table {
    protected $_name = "acl_roles";

    public function ensure($role = null, $parents = array()) {
        $roleId = $this->insert(array(
            'code' => $role,
            'type' => 'user',
            'date_creation' => date('Y-m-d H:i:s'),
        ));
        $table = new Acl_Application_Db_AclHierarchy();
        $table->ensureParents($roleId, $parents);
        return $roleId;
    }
}