module ::Openstack
  def db_uri_ec2api(service, user, pass, is_slave = false) # rubocop:disable MethodLength, CyclomaticComplexity
    info = db(service)
    return unless info

    host = info['host']
    port = info['port'].to_s
    
    type = info['service_type']
    name = info['db_name']
    options = info['options'][type]

    # Normalize to the SQLAlchemy standard db type identifier
    case type
    when 'pgsql'
      type = 'postgresql'
    when 'mariadb', 'galera', 'percona-cluster'
      type = 'mysql'
    end

    # Build uri
    case type
    when 'mysql', 'postgresql'
      "#{type}://#{user}:#{pass}@#{host}:#{port}/#{name}#{options}"
    when 'sqlite'
      # SQLite uses filepaths not db name
      # README(galstrom): 3 slashes is a relative path, 4 slashes is an absolute path
      #  example: info['path'] = 'path/to/foo.db' -- will return sqlite:///foo.db
      #  example: info['path'] = '/path/to/foo.db' -- will return sqlite:////foo.db
      path = info['path']
      "#{type}:///#{path}#{options}"
    end
  end
end