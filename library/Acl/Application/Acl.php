<?php
/**
 * Created by PhpStorm.
 * User: aleksandr
 * Date: 26.02.14
 * Time: 23:44
 */

class Acl_Application_Acl extends Zend_Acl {
    const GUEST = 'guest';
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

        $table = new Acl_Application_Db_AclHierarchy();
        $hie = $table->fetchAll();

        $this->ensureRoles($roles, $hie, $availableRoles);
        $this->setCurrentRole(self::GUEST);
    }

    private function ensureRoles($roles, $hie, &$existed) {
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
                    $this->logger->log("Creation role: '" . $role['role'] . "'", Zend_Log::DEBUG);
                    $this->addRole($role['role'], $parents);
                }
            }
        }
        if ($repeat)
            $this->ensureRoles($roles, $hie, $existed);
        foreach ($roles as $rolePrivileges) {
            $mode = $rolePrivileges['mode'];
            if (null == $mode) continue;
            $resource = new Acl_Application_AclResource($rolePrivileges['resource']);
            if (!$this->has($resource)) {
                $this->logger->log("Creation resource '" . $resource->getResourceId(), Zend_Log::DEBUG);
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
        $this->logger->log("Current role changed: '" . $this->_role . "' > '" . $role . "'", Zend_Log::INFO);
        $this->_role = $role;
        $this->fixate();
    }

    public function setCurrentRoleByUserId($userId) {
        $table = new Acl_Application_Db_AclUser();
        $role = $table->getByUserId($userId);
        $this->setCurrentRole($role);
    }

    protected function fixate() {
        $session = new Zend_Session_Namespace(self::SESSION_ALIAS);
        $session->acl = serialize(self::$_instance);
    }

    public function ensureRole($userId, $parents = array()) {
        $table = new Acl_Application_Db_AclUser();
        $table->ensureRole($userId, $parents);
    }

    public function getCurrentHierarchy() {
        $hie = array();
        $current = $this->getCurrentRole();
        foreach($this->getRoles() as $role) {
            if ($this->inheritsRole($current, $role)) {
                $hie[] = $role;
            }
        }
    }
}