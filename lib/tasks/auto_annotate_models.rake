if Rails.env.development?
  task :set_annotation_options do
    # Just some example settings from annotate 2.6.0.beta1
    Annotate.set_defaults(
      'routes'                     => 'false',
      'position_in_routes'         => 'before',
      'position_in_class'          => 'before',
      'position_in_test'           => 'before',
      'position_in_fixture'        => 'before',
      'position_in_factory'        => 'before',
      'position_in_serializer'     => 'before',
      'show_foreign_keys'          => 'true',
      'show_complete_foreign_keys' => 'false',
      'show_indexes'               => 'true',
      'simple_indexes'             => 'false',
      'model_dir'                  => 'app/models',
      'root_dir'                   => '',
      'include_version'            => 'false',
      'require'                    => '',
      'exclude_tests'              => 'false',
      'exclude_fixtures'           => 'false',
      'exclude_factories'          => 'false',
      'exclude_serializers'        => 'false',
      'exclude_scaffolds'          => 'true',
      'exclude_controllers'        => 'true',
      'exclude_helpers'            => 'true',
      'exclude_sti_subclasses'     => 'false',
      'ignore_model_sub_dir'       => 'false',
      'ignore_columns'             => nil,
      'ignore_routes'              => nil,
      'ignore_unknown_models'      => 'false',
      'hide_limit_column_types'    => 'integer,boolean',
      'hide_default_column_types'  => 'json,jsonb,hstore',
      'skip_on_db_migrate'         => 'false',
      'format_bare'                => 'true',
      'format_rdoc'                => 'false',
      'format_markdown'            => 'false',
      'sort'                       => 'false',
      'force'                      => 'false',
      'classified_sort'            => 'false',
      'trace'                      => 'false',
      'wrapper_open'               => nil,
      'wrapper_close'              => nil,
      'with_comment'               => true
    )
  end

  # Comes with the current master when running `rails g annotate:install`
  # But somehow won't annotate my models correctly (only one)
  # Thus commented out
  # Annotate.load_tasks

  # Annotate models
  task :annotate do
    puts 'Annotating models...'
    system 'bundle exec annotate'
  end

  # Run annotate task after db:migrate
  #  and db:rollback tasks
  Rake::Task['db:migrate'].enhance do
    Rake::Task['annotate'].invoke
  end

  Rake::Task['db:rollback'].enhance do
    Rake::Task['annotate'].invoke
  end
end