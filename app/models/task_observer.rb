class TaskObserver < ActiveRecord::Observer
  def after_create(task)
    Task.delay.add_deliver(task.id)
  end

  def before_update(task)
    @assignable_id = task.assignable_id
    @assignable_type = task.assignable_type
  end

  def after_update(task)
    Task.delay.update_deliver(task.id, @assignable_id, @assignable_type)
  end
end
