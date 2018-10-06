class NotesController < ApplicationController

  def create
    note = Note.new(note_parameters)
    note.save
    redirect_to readings_path
  end

  def destroy
    @note = Note.find(params[:id])
    @note.destroy if @note
    redirect_to readings_path
  end

  private

  def note_parameters
    params.require(:note).permit(:content, :happend)
  end

end
