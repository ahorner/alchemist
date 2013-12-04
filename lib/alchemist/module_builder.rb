module Alchemist
  class ModuleBuilder
    def initialize category
      @category = category
    end

    def build
      Module.new.tap do |category_module|
        category_module.class_eval %(def self.inspect() "#<Module(#{category})>" end)
        category_module.class_eval category_methods
      end
    end

    private
    attr_reader :category

    def library
      Alchemist.library
    end

    def category_methods
      unit_names.map do |name|
        %(define_method("#{name}") { Alchemist.measure self, :#{name} }) + "\n" + prefixed_methods(name)
      end.join("\n")
    end

    def unit_names
      library.unit_names(category)
    end

    def prefixes_with_value(name)
      if library.si_units.include?(name.to_s)
        library.unit_prefixes
      else
        []
      end
    end

    def prefixed_methods(name)
      prefixes_with_value(name).map do |prefix, value|
        %(define_method("#{prefix}#{name}") { Alchemist.measure self, :#{name}, #{value} })
      end.join("\n")
    end
  end
end
