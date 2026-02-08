extends Node

const LINES := {
	"found_item": "I found something over here!",
	"heard_sound": "What was that sound? I better tell the investigator.",
	"found_something_look_over_there": "Hey, I heard a strange sound. Could you check it out?",
	"i_will_go_investigate": "Thanks, I will go check it out",
	"found_clue_1": "This medicine bottle should't be empty, this looks like either an overdose or poisoning",
	"found_clue_1_after_journal": "This medicine bottle shouldn't be empty. This looks like the poison used",
	"found_clue_2": "This will lists both the son and daughter and beneficiares, maybe this shows a motive",
	"found_clue_2_after_daughter_asked_no_medicine_bottle": "Well, this will lists both the son and daughter as beneficiares, both of them had a motive to commit the murder. However, this doesn't disprove the journal so I believe the daughter is guilty. I still don't haven't found the posison yet though.",
	"found_clue_3": "This journal shows the daughter planning the murder and deciding to use poison. I'm going to go ask her to explain this.",
	"found_clue_4": "This laptop shows the son looking up how to poison someone. I'm going to go ask him about this.",
	"found_clue_4_again": "The son wasn't even here when this was searched. Someone is trying to frame the son",
	"question_daugher_about_journal": "Hey, explain why this journal shows you plotting the murder",
	"daughter_respond_to_journal_question_computer_redirect": "That must be forged, here look at this computer, it seems suspicious",
	"daughter_respond_to_journal_question_will_redirect": "That must be forged, here look at this document, it seems suspicious",
	"daughter_respond_to_journal_question_give_up": "I confess, I committed the murder",
	"i_will_go_investigate_the_laptop": "Ok, I will go investigate the computer",
	"i_will_go_investigate_the_will": "Ok, I will investigate the will",
	"question_son_about_laptop": "Hey, there's a laptop with search history showing that you searched how to poison someone. What do you have to say?",
	"son_respond_to_laptop_question": "I didn't search that. Could you investigate it again and double check?",
	"daughter_guilty_and_tried_framing_son": "I believe I have solved the murder. The daughter is guilty, she poisoned the victim, wrote her plans in her journal, and then tried to frame the son. The handwriting will have to be evaluated in court.",
	"daughter_guilty_and_tried_framing_son_but_no_death_weapon": "I believe I have solved the murder. The daughter is guilty and wrote her plans in her journal, and then tried to frame the son. The handwriting will have to be evaluated in court. However, I still have not found the poison she wrote about using.",
	"solved_murder_medicine_last": "Well that's it. I now have the suspect, the motive, and the poison used. All that's left is a trial.",
	"solved_murder_will_last": "Well that's it. Now I have motive, suspect, and the poison used. All that's left is a trial.",
	"solved_murder_journal_last": "Well that's it. I now have the suspect, who has confessed, the poison used, and a motive. ALl that's left is a trial"
}
