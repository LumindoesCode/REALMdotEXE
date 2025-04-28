LumHelp = {}

LumHelp.callbacks = {}

function LumHelp.AddCallback(obj, func) 
  local cb = {}
  cb.ID = obj
  cb.FUNCTION = func
  table.insert(LumHelp.callbacks, cb)
end

callbackData = global_data()

callbackData.Step = function()
  if (paused ~= true) then
    if (#LumHelp.callbacks > 0) then
      for ind, callback in ipairs(LumHelp.callbacks) do
        if (call_function("instance_exists", {callback.ID}) ~= 0) then
          callback.FUNCTION(callback.ID)
        else
          table.remove(LumHelp.callbacks, ind)
        end
      end
    end
  end
end

register_data(callbackData)