begin
    update users
    set is_active = 0
    where sign_date < to_date('01.01.2016', 'dd.mm.yyyy');

    insert into users
    values(4, 'UserD', SYSDATE,1);
end;
