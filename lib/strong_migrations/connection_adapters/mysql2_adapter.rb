module StrongMigrations
  module ConnectionAdapters
    module Mysql2Adapter
      def execute(sql, name = nil)
        sql = add_lock_none(sql)
        super(sql, name)
      end
  

      private

      def add_lock_none(sql)
        if StrongMigrations.force_lock_none && sql.upcase.include?('ALTER TABLE')
          sql = "#{sql.chomp(";")}, LOCK=NONE;"
        end
        sql
      end
    end
  end
end
