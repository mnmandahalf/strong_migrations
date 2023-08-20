module StrongMigrations
  module ConnectionAdapters
    module Mysql2Adapter
      def execute(sql, name = nil)
        sql = add_algorithm_instant(sql)
        sql = add_lock_none(sql)
        super(sql, name)
      end
  

      private

      def add_lock_none(sql)
      end

      def add_algorithm_instant(sql)
        if StrongMigrations.force_instant_ddl && is_target_for_check_online_ddl?(sql)
          sql = sql.gsub(/,\s*ALGORITHM\s*=\s*\w+\s*/i, '').squeeze(' ').strip
          sql = "#{sql.chomp(";")}, ALGORITHM=INSTANT;"
        end
        sql
      end

      def add_lock_none(sql)
        if StrongMigrations.force_lock_none && !StrongMigrations.force_instant_ddl && is_target_for_check_online_ddl?(sql)
          sql = sql.gsub(/,\s*LOCK\s*=\s*\w+\s*/i, '').squeeze(' ').strip
          sql = "#{sql.chomp(";")}, LOCK=NONE;"
        end
        sql
      end

      def is_target_for_check_online_ddl?(sql)
        sql.upcase.include?('ALTER TABLE') ||
          sql.upcase.include?('CREATE INDEX') ||
          sql.upcase.include?('CREATE UNIQUE INDEX') ||
          sql.upcase.include?('CREATE FULLTEXT INDEX') ||
          sql.upcase.include?('CREATE SPATIAL INDEX') ||
          sql.upcase.include?('ALTER INDEX') ||
          sql.upcase.include?('DROP INDEX')
      end
    end
  end
end
