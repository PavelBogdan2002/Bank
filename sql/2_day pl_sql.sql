declare
    l_name varchar2(20) := 'Max';
begin
    if l_name = 'Admin' then
        dbms_output.put_line('Пользователь админ');
    elsif l_name = 'Alex' then
        dbms_output.put_line('Пользователь Alex');
    elsif l_name = 'Kat' then
        dbms_output.put_line('Пользователь Kat');
    else
        dbms_output.put_line('anonumus');
    end if;
end;
