class FullTinyMceController < ApplicationController

  uses_tiny_mce :options => {
    
    :plugins => ['spellchecker'] },
                :raw_options => '',
                :only => ['new_page', 'edit_page']
  include TinyMCEActions

end
