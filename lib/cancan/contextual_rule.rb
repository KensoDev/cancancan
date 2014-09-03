module CanCan
  class ContextualRule < CanCan::Rule
    attr_reader :base_behavior, :subjects, :actions, :contexts, :contextual

    def initialize(base_behavior, action, subject, context, block)
      super(base_behavior, action, subject, nil, block)
      @contexts = [context].flatten
      @contextual = true
    end

    def relevant?(action, subject, context)
      subject = subject.values.first if subject.class == Hash
      @match_all || (matches_action?(action) && matches_subject?(subject)) && matches_context?(context)
    end

    def matches_context?(context)
      @contexts.include?(context) || matches_context_class?(context)
    end

    def matches_context_class?(context)
      @contexts.any? do |con|
        con.kind_of?(Module) && (context.kind_of?(con) || context.class.to_s == con.to_s || context.kind_of?(Module) && context.ancestors.include?(con))
      end
    end

    def matches_conditions?(action, subject, context)
      if @block
        @block.call(subject, context)
      end
    end

  end
end
