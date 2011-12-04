module Ids
  def ids(id = :id)
    connection.select_values(select("#{table_name}.#{id}").to_sql)
  end
  
  def attribute(name)
    ids(name)
  end
  
  def attributes(fields)
    connection.select_all(select(fields).to_sql)
  end
end

ActiveRecord::Relation.send :include, Ids