<?php
/**
 * Created by PhpStorm.
 * User: aleksandr
 * Date: 26.02.14
 * Time: 23:44
 */

class Acl_Application_Acl extends Zend_Acl {
    const GUEST = 1;
    const REGISTER_ALIAS = "acl-acl";
    const SESSION_ALIAS = "acl-acl";

    static protected $_instance;
    protected $_role;
    /** @var $logger Zend_Log */
    protected $logger;

    protected function __construct() {
        $this->logger = Zend_Registry::get('logger')->ensureStream('acl');
        $this->init();
        $this->getRoles();
    }

    public static function getInstance() {
        if (null == self::$_instance) {
            $session = new Zend_Session_Namespace(self::SESSION_ALIAS);
            if (null == $session->acl) {
                self::$_instance = new self();
                $session->acl = serialize(self::$_instance);
            } else {
                self::$_instance = unserialize($session->acl);
            }
        }
        return self::$_instance;
    }

    private function init() {
        $availableRoles = array();

        $table = new Acl_Application_Db_AclRoles();
        $roles = $table->fetchAll();
//        $roles = $db->getAllRoles();

        $table = new Acl_Application_Db_AclHierarchy();
        $hie = $table->fetchAll();
//        $hie = $db->getHie();

        Zend_Debug::dump($roles->toArray());
        Zend_Debug::dump($hie->toArray());

//        $this->ensureRoles($roles, $hie, $availableRoles);
//        $this->setCurrentRole(self::GUEST);
    }

    /*private function ensureRoles($roles, $hie, &$existed) {
        $repeat = false;
        foreach($hie as $role) {
            if (!in_array($role['role'], $existed)) {
                $process = true;
                if (null != $role['parents']) {
                    foreach (explode(",", $role['parents']) as $parent) {
                        if (!in_array($parent, $existed)) {
                            $process = false;
                            $repeat = true;
                            break;
                        }
                    }
                }
                if ($process) {
                    $existed[] = $role['role'];
                    $parents = explode(",", $role['parents']);
                    if (0 == count($parents) || '' == $role['parents'])
                        $parents = null;
                    Pro_Log::log("Creation role: '" . $role['role'] . "'", "acl");
                    Zend_Registry::get('logger')->log("Creation role: '" . $role['role'] . "'", "acl");
                    $this->addRole($role['role'], $parents);
                }
            }
        }
        if ($repeat)
            $this->ensureRoles($roles, $hie, $existed);
        foreach ($roles as $rolePrivileges) {
            $mode = $rolePrivileges['mode'];
            if (null == $mode) continue;
            $resource = new Pro_Acl_Resource($rolePrivileges['resource']);
            if (!$this->has($resource)) {
                Pro_Log::log("Creation resource '" . $resource->getResourceId(), "acl");
                Zend_Registry::get('logger')->log("Creation resource '" . $resource->getResourceId(), "acl");
                $this->addResource($resource);
            }
            $privilege = '__full__' == $rolePrivileges['privilege'] || null  == $rolePrivileges['privilege']
                ? null : explode(',', $rolePrivileges['privilege']);
            $this->$mode($rolePrivileges['role'], $rolePrivileges['resource'], $privilege);
        }
    }

    public function isCurrentlyAllowed($resource = null, $privilege = null) {
        return $this->isAllowed($this->_role, $resource, $privilege);
    }

    public function getCurrentRole() {
        return $this->getRole($this->_role);
    }

    public function setCurrentRole($role) {
        Pro_Log::log("Current role changed: '" . $this->_role . "' > '" . $role . "'", "acl");
        $this->_role = $role;
        $this->fixate();
    }

    public function setCurrentRoleByUserId($userId) {
        $db = new Pro_Acl_Db();
        $this->setCurrentRole($db->getUserRole($userId));
    }

    protected function fixate() {
        $session = new Zend_Session_Namespace(self::$_sessionKey);
        $session->acl = serialize(self::$_instance);
    }

    public function ensureRole($userId, $parents) {
        $db = new Pro_Acl_Db();
        $db->ensureRole($userId, null, $parents);
    }

    public function getCurrentHierarchy() {
        $hie = array();
        $current = $this->getCurrentRole();
        foreach($this->getRoles() as $role) {
            if ($this->inheritsRole($current, $role)) {
                $hie[] = $role;
            }
        }
    }*/
}