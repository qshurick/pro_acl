
delete from acl_user;
delete from acl_hierarchy;
delete from acl_roles_structure;
delete from acl_privileges;
delete from acl_resources;
delete from acl_roles;

insert into acl_roles (id, code, type, date_creation, description) values
	(1, 'guest', 'system', now(), 'Default guest role'),
	(2, 'admin', 'system', now(), 'Admin role'),
	(3, 'trader:base', 'system', now(), 'Default trader role, user before registration checking'),
	(4, 'trader:full', 'system', now(), 'Full trading support'),
	(5, 'trader:ib', 'system', now(), 'IB support');

insert into acl_resources (id, code, date_creation, description) values
	(1, 'account', now(), 'Adnim interface'),
	(2, 'dashboard', now(), 'Adnim interface'),
	(3, 'default', now(), 'Adnim interface'),
	(4, 'payment', now(), 'Adnim interface'),
	(5, 'profile', now(), 'Adnim interface'),
	(6, 'settings', now(), 'Adnim interface'),
	(7, 'trader', now(), 'Adnim interface'),
	(8, 'user', now(), 'Adnim interface');

insert into acl_resources (id, code, date_creation, description) values
	(9, 'account', now(), 'Trader interface'),
	(10, 'account-open', now(), 'Trader interface'),
	(11, 'dashboard', now(), 'Trader interface'),
	(12, 'default', now(), 'Trader interface'),
	(13, 'deposit', now(), 'Trader interface'),
	(14, 'ib', now(), 'Trader interface'),
	(15, 'payment', now(), 'Trader interface'),
	(16, 'profile', now(), 'Trader interface'),
	(17, 'public', now(), 'Trader interface'),
	(18, 'support', now(), 'Trader interface'),
	(19, 'welcome', now(), 'Trader interface'),
	(20, 'withdrawal', now(), 'Trader interface');

insert into acl_privileges (id, resource_id, code, date_creation, description) values
	(1, 1, '__full__', now(), ''),
	(2, 2, '__full__', now(), ''),
	(3, 3, '__full__', now(), ''),
	(4, 4, '__full__', now(), ''),
	(5, 5, '__full__', now(), ''),
	(6, 6, '__full__', now(), ''),
	(7, 7, '__full__', now(), ''),
	(8, 8, '__full__', now(), ''),
	(9, 9, '__full__', now(), ''),
	(10, 10, '__full__', now(), ''),
	(11, 11, '__full__', now(), ''),
	(12, 12, '__full__', now(), ''),
	(13, 13, '__full__', now(), ''),
	(14, 14, '__full__', now(), ''),
	(15, 15, '__full__', now(), ''),
	(16, 16, '__full__', now(), ''),
	(17, 17, '__full__', now(), ''),
	(18, 18, '__full__', now(), ''),
	(19, 19, '__full__', now(), ''),
	(20, 20, '__full__', now(), '');

insert into acl_roles_structure (role_id, privilege_id, mode) values
	(2, 1, 'allow'), -- admin
	(2, 2, 'allow'), -- admin
	(1, 3, 'allow'), -- guest
	(2, 4, 'allow'), -- admin
	(2, 5, 'allow'), -- admin
	(2, 6, 'allow'), -- admin
	(2, 7, 'allow'), -- admin
	(1, 8, 'allow'), -- guest
	(3, 9, 'allow'), -- trader:base
	(3, 10, 'allow'), -- trader:base
	(3, 11, 'allow'), -- trader:base
	(1, 12, 'allow'), -- guest
	(3, 13, 'allow'),  -- trader:base
	(5, 14, 'allow'), -- trader:ib
	(3, 15, 'allow'), -- trader:base
	(3, 16, 'allow'), -- trader:base
	(1, 17, 'allow'), -- guest
	(3, 18, 'allow'), -- trader:base
	(3, 19, 'allow'), -- trader:base
	(4, 20, 'allow'); -- trader:full

insert into acl_hierarchy (role_id, parent_role_id) values
	(1, null),
	(2, 1),
	(3, 1),
	(4, 3),
	(5, 4);

-- user migration:
insert into acl_roles (code, type, date_creation)
	select concat('user-', id), 'user', now() from trader;
insert into acl_hierarchy (role_id, parent_role_id)
	select id, 4 from acl_roles where code like 'user-%';
insert into acl_user (role_id, user_id)
	select r.id, u.id from acl_roles r, trader u where r.code = concat('user-', u.id);
-- admin migration
insert into acl_roles (code, type, date_creation)
	select concat('admin-', id), 'user', now() from admin;
insert into acl_hierarchy (role_id, parent_role_id)
	select id, 2 from acl_roles where code like 'admin-%';
insert into acl_user (role_id, user_id)
	select r.id, u.id from acl_roles r, admin u where r.code = concat('admin-', u.id);