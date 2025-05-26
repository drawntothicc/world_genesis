import { useBackend } from '../backend';
import { Box, Button, LabeledList, NumberInput, Section } from '../components';
import { Window } from '../layouts';

export const TransformTool = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    able_to_speak,
    able_to_emote,
    scale_object,
    show_that_object_is_tf,
    linked_item_name,
    able_to_struggle_out,
  } = data;

  return (
    <Window
      width={340}
      height={280}>
      <Window.Content>
        <Section>
          <Box textAlign="center" fontSize="16px">
            <b>Current item:</b> {linked_item_name ? linked_item_name : "None"}
          </Box>
          <br />

          <Button
            fluid
            color={able_to_speak ? 'green' : 'red'}
            onClick={() => act('set_speaking', {})}>
            Able to Speak: {able_to_speak ? "True" : "False"}
          </Button>

          <Button
            fluid
            color={able_to_emote ? 'green' : 'red'}
            onClick={() => act('set_emote', {})}>
            Able to Emote: {able_to_emote ? "True" : "False"}
          </Button>

          <Button
            fluid
            color={scale_object ? 'green' : 'red'}
            onClick={() => act('set_scale', {})}>
            Resize: {scale_object ? "True" : "False"}
          </Button>

          <Button
            fluid
            color={scale_object ? 'green' : 'red'}
            onClick={() => act('toggle_struggle', {})}>
            Able to struggle out: {able_to_struggle_out ? "True" : "False"}
          </Button>

          <Button
            fluid
            color={show_that_object_is_tf ? 'green' : 'red'}
            onClick={() => act('set_show_desc', {})}>
            Show examine text: {show_that_object_is_tf ? "True" : "False"}
          </Button>

        </Section>
      </Window.Content>
    </Window>
  );
};
