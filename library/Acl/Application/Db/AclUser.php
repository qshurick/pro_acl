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
    public function getByUserId($userId) {
        $select = $this->select()->where('user_id = ?', $userId);
        $row = $this->fetchRow($select);
        $role = $row->findParentRow("acl_roles");
        return $role->code;
    }
    public function ensureRole($userId, $parents = array()) {
        $roleName = uniqid("user-$userId-");
        $table = new Acl_Application_Db_AclRoles();
        $roleId = $table->ensure($roleName, $parents);
        $this->insert(array(
            'role_id' => $roleId,
            'user_id' => $userId
        ));
    }
}